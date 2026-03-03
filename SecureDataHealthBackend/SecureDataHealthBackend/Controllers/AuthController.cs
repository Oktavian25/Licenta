using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Identity;
using SecureDataHealthBackend.Models;

namespace SecureDataHealthBackend.Controllers;

[ApiController]
[Route("auth")]
public class AuthController : ControllerBase
{
    private readonly UserManager<ApplicationUser> _userManager;
    
    public AuthController(UserManager<ApplicationUser> userManager)
    {
        _userManager = userManager;
    }

    [HttpPost("register")]
    public async Task<IActionResult> Register(RegisterRequest request)
    {
        if (!Enum.IsDefined(typeof(UserRole), request.Role))
        {
            return BadRequest("Invalid role.");
        }
        
        var user = new ApplicationUser
        {
            UserName  = request.Email,
            Email     = request.Email,
            FirstName = request.FirstName,
            LastName  = request.LastName,
            Country   = request.Country
        };
        var registerResult = await _userManager.CreateAsync(user, request.Password);

        if (!registerResult.Succeeded)
        {
            return BadRequest(registerResult.Errors);
        }
        
        await _userManager.AddToRoleAsync(user, request.Role.ToString());
        return Ok();
    }
}