using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using SecureDataHealthBackend.Models;

namespace SecureDataHealthBackend.Data;

public class AuthDbContext : IdentityDbContext<ApplicationUser>
{
    public AuthDbContext(DbContextOptions options) : base(options){}
    
    public DbSet<PatientProfile> PatientProfiles => Set<PatientProfile>();
    public DbSet<DoctorProfile> DoctorProfiles => Set<DoctorProfile>();
    
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);
        
        modelBuilder.Entity<PatientProfile>().HasKey(p=>p.Id);
        modelBuilder.Entity<DoctorProfile>().HasKey(d => d.Id);
        
        modelBuilder.Entity<PatientProfile>()
            .HasOne(p => p.User)
            .WithOne(u => u.PatientProfile)
            .HasForeignKey<PatientProfile>(p => p.Id)
            .OnDelete(DeleteBehavior.Cascade);
        
        modelBuilder.Entity<DoctorProfile>()
            .HasOne(d => d.User)
            .WithOne(u => u.DoctorProfile)
            .HasForeignKey<DoctorProfile>(d => d.Id)
            .OnDelete(DeleteBehavior.Cascade);
    }
}