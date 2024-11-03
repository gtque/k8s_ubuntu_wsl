package com.thehangingpen.examples.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.Arrays;

@Configuration
@EnableMethodSecurity
public class SecurityConfig {

    InMemoryUserDetailsManager userDetailsService;

    private static final String[] SWAGGER_PATTERNS = {
            "/swagger-resources/**",
            "/swagger-ui/**",
            "/webjars/**",
            "/v2/api-docs"
    };

    private final boolean apiDocumentationEnabled;

    public SecurityConfig(
            @Value("${project.features.api-documentation.enabled:false}") final boolean apiDocumentationEnabled
    ) {
        this.apiDocumentationEnabled = apiDocumentationEnabled;
    }

    @Bean
    public InMemoryUserDetailsManager userDetailsService() {

        userDetailsService = new InMemoryUserDetailsManager(User.builder()
                .username("test")
                .password(passwordEncoder().encode("password"))
                .roles("USER")
                .build());

        return userDetailsService;
    }

    @Bean
    public DaoAuthenticationProvider authenticationProvider() {
        DaoAuthenticationProvider authProvider = new DaoAuthenticationProvider();

        authProvider.setUserDetailsService(userDetailsService());
        authProvider.setPasswordEncoder(passwordEncoder());

        return authProvider;
    }

    /**
     * Setup spring security
     * <p>Swagger and associated resources are open to all callers.
     * <p>Actuators are open to all callers
     * <p>All other endpoints are subject to Bearer authentication. The token itself is not specifically validated
     * in this service. Expectation is that the underlying Domain will check token validity.
     *
     * @param http
     * @throws Exception
     */
//    @Override
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {

        AuthenticationManagerBuilder authenticationManagerBuilder = http.getSharedObject(AuthenticationManagerBuilder.class);
        authenticationManagerBuilder.userDetailsService(userDetailsService()).passwordEncoder(passwordEncoder());
        AuthenticationManager authenticationManager = authenticationManagerBuilder.build();
        // disable session management
        http.sessionManagement(sessionManagement -> sessionManagement.sessionCreationPolicy(SessionCreationPolicy.STATELESS));

        // apply path-based security rules

        if (apiDocumentationEnabled) {
            // only allow access to swagger resources if enabled
            http.authorizeHttpRequests(auth -> auth.requestMatchers(SWAGGER_PATTERNS).permitAll());
        } else {
            // otherwise return 401/403
            http.authorizeHttpRequests(auth -> auth.requestMatchers(SWAGGER_PATTERNS).denyAll());
        }

        http.authorizeHttpRequests(auth -> auth.requestMatchers("/actuator/**").permitAll()
                .requestMatchers("/hello/world").permitAll()
                .requestMatchers("/games").permitAll()
                // all other requests subject to basic auth
                //see the username/password defined above for inMemoryAuthentication
                .anyRequest().authenticated())
                .authenticationManager(authenticationManager)
                .httpBasic(Customizer.withDefaults());

        http.authenticationProvider(authenticationProvider());
        // let spring security handle CORS, so that it gets invoked at the correct point in the filter chain
//        http.cors();

        // csrf is irrelevant for api
        http.csrf(csrf -> csrf.disable());

        return http.build();
    }

    @Bean
    CorsConfigurationSource corsConfigurationSource() {
        // preflight should allow all requests from all origins
        final CorsConfiguration configuration = new CorsConfiguration()
                .applyPermitDefaultValues();
        String[] listOf = {HttpMethod.GET.name(),
                HttpMethod.POST.name(),
                HttpMethod.PUT.name(),
                HttpMethod.PATCH.name(),
                HttpMethod.DELETE.name(),
                HttpMethod.HEAD.name()};
        configuration.setAllowedMethods(Arrays.asList(listOf));

        final UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

}

