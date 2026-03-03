namespace SecureDataHealthBackend.Models;

public class DoctorProfile
{
    public string Id { get; set; } = "";
    public ApplicationUser User { get; set; } = null!;
    
    public string? PhoneNumber { get; set; }
    public string? Specialty { get; set; }
    public string? LicenceNumber { get; set; }
    public string? ClinicName { get; set; }
}
    