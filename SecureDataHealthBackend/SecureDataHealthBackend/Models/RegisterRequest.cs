namespace SecureDataHealthBackend.Models;

public class RegisterRequest
{
    public string Email { get; set; } = "";
    public string Password { get; set; } = "";
    public string FirstName { get; set; } = "";
    public string LastName { get; set; } = "";
    public string Country { get; set; } = "";
    public UserRole Role { get; set; }
}