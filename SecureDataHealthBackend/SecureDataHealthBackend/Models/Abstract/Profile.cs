namespace SecureDataHealthBackend.Models;

public abstract class Profile
{
    public ApplicationUser User { get; set; } = null!;
}