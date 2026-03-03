using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using SecureDataHealthBackend.Data;
using SecureDataHealthBackend.DTOs;
using SecureDataHealthBackend.Models;

namespace SecureDataHealthBackend.Controllers;

[Authorize]
[ApiController]
[Route("profile")]
public class ProfileController : ControllerBase
{
    private readonly AuthDbContext _db;
    private readonly UserManager<ApplicationUser> _userManager;

    public ProfileController(AuthDbContext db, UserManager<ApplicationUser> userManager)
    {
        _db = db;
        _userManager = userManager;
    }

    [HttpGet("me")]
    public async Task<IActionResult> Me()
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
        if (userId == null)
        {
            return Unauthorized();
        }
        
        var user = await _userManager.FindByIdAsync(userId);
        if (user == null)
        {
            return Unauthorized();
        }
        
        var roleRaw = await _userManager.GetRolesAsync(user);
        var role = roleRaw.FirstOrDefault();

        if (string.Equals(role, nameof(UserRole.Doctor)))
        {
            return Ok(new
            {
                userId = user.Id,
                email = user.Email,
                firstName = user.FirstName,
                lastName = user.LastName,
                country = user.Country,
                phoneNumber = user.DoctorProfile?.PhoneNumber,
                specialty = user.DoctorProfile?.Specialty,
                clinicName = user.DoctorProfile?.ClinicName,
                licenceNumber = user.DoctorProfile?.LicenceNumber
            });
        }

        if (string.Equals(role, nameof(UserRole.Patient)))
        {
            return Ok(new
            {
                userId = user.Id,
                email = user.Email,
                firstName = user.FirstName,
                lastName = user.LastName,
                country = user.Country,
                dateOfBirth = user.PatientProfile?.DateOfBirth,
                phoneNumber = user.PatientProfile?.PhoneNumber,
                gender = user.PatientProfile?.Gender,
            }); 
        }
        return BadRequest("Unknown role");
    }
    
    [HttpPost("doctor")]
    [Authorize(Roles = nameof(UserRole.Doctor))]
    public async Task<IActionResult> UpsertDoctor([FromBody] DoctorProfileDto request)
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
        if (userId == null)
        {
            return Unauthorized();
        }
        
        var profile = await _db.DoctorProfiles.FirstOrDefaultAsync(d => d.Id == userId);

        if (profile is null)
        {
            profile = new DoctorProfile { Id = userId };
            _db.DoctorProfiles.Add(profile);
        }

        profile.PhoneNumber = request.PhoneNumber;
        profile.Specialty = request.Specialty;
        profile.LicenceNumber = request.LicenceNumber;
        profile.ClinicName = request.ClinicName;

        await _db.SaveChangesAsync();
        return Ok();
    }
    
    [HttpPost("patient")]
    [Authorize(Roles = nameof(UserRole.Patient))]
    public async Task<IActionResult> UpsertPatient([FromBody] PatientProfileDto request)
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
        if (userId == null)
        {
            return Unauthorized();
        }
        
        var profile = await _db.PatientProfiles.FirstOrDefaultAsync(p => p.Id == userId);

        if (profile is null)
        {
            profile = new PatientProfile { Id = userId };
            _db.PatientProfiles.Add(profile);
        }

        profile.DateOfBirth = request.DateOfBirth;
        profile.PhoneNumber = request.PhoneNumber;
        profile.Gender = request.Gender;

        await _db.SaveChangesAsync();
        return Ok();
    }

}