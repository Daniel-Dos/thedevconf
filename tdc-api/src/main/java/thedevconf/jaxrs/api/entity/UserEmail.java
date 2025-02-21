package thedevconf.jaxrs.api.entity;

import io.quarkus.hibernate.orm.panache.PanacheEntityBase;
import java.util.Objects;
import java.util.Optional;
import javax.persistence.*;
import java.time.LocalDateTime;
import javax.validation.constraints.Email;
import javax.validation.constraints.NotNull;

@Entity
@Table(name = "UserEmail_tdc")
public class UserEmail extends PanacheEntityBase {
    @Id
    @NotNull
    @Email
    String email;
    LocalDateTime validatedAt;
    @ManyToOne
    User user;

    public static boolean containsByEmail(String email) {
        return UserEmail.count("email", email) > 0;
    }

    public static Optional<UserEmail> findByEmail(String email) {
        return UserEmail.findByIdOptional(email);
    }

    public static UserEmail newFromSessionAndUser(UserSession session, User user) {
        final var emailAddress = session.getEmail();
        return newFromEmailAndUser(emailAddress, user);
    }

    public static UserEmail newFromEmailAndUser(final String emailAddress, final User user) {
        var emailRef = UserEmail.findByEmail(emailAddress);
        if (emailRef.isPresent()) {
            final var userEmail = emailRef.get();
            if (Objects.equals(userEmail.user, user)) {
                return userEmail;
            }
            throw new IllegalArgumentException("email already registered by another user");
        }
        UserEmail email = new UserEmail();
        email.email = emailAddress;
        email.user = user;
        email.validatedAt = LocalDateTime.now(); //TODO: Actually check
        email.persist();
        return email;
    }

    public String getEmail() {
        return email;
    }

    public LocalDateTime getValidatedAt() {
        return validatedAt;
    }

    public User getUser() {
        return user;
    }
}
