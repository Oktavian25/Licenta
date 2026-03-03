using Microsoft.AspNetCore.Identity;
using SecureDataHealthBackend.Models;

namespace SecureDataHealthBackend.Services;

public class SeedService
{
    private readonly RoleManager<IdentityRole> _roleManager;

    public SeedService(RoleManager<IdentityRole> roleManager)
    {
        _roleManager = roleManager;
    }

    public async Task SeedRoles()
    {
        foreach (var role in Enum.GetNames(typeof(UserRole)))
        {
            if (!await _roleManager.RoleExistsAsync(role))
            {
                var result = await _roleManager.CreateAsync(new IdentityRole(role));
                if (!result.Succeeded)
                {
                    throw new Exception("Failed to create role: " + role);
                }   
            }
        }
    }
    
    
}