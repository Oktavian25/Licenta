namespace SecureDataHealthBackend.Models;

public class PatientProfile
{
    public string Id { get; set; } = "";
    public ApplicationUser User { get; set; } = null!;

    public DateTime? DateOfBirth { get; set; }
    public string? PhoneNumber { get; set; }
    public string? Gender { get; set; }
}