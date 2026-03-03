using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using SecureDataHealthBackend.Data;
using SecureDataHealthBackend.Models;
using SecureDataHealthBackend.Services;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddDbContext<AuthDbContext>(options =>
{
    options.UseSqlite(builder.Configuration.GetConnectionString("DefaultConnection"));
}); 

builder.Services.AddAuthorization();

builder.Services
    .AddIdentityApiEndpoints<ApplicationUser>()
    .AddRoles<IdentityRole>()
    .AddEntityFrameworkStores<AuthDbContext>();

builder.Services.AddSwaggerGen(c =>
{   
    c.CustomSchemaIds(t => t.FullName);
});

builder.Services.AddScoped<SeedService>();

var app = builder.Build();

app.MapIdentityApi<ApplicationUser>(); 

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

using (var scope = app.Services.CreateScope())
{
    var seeder = scope.ServiceProvider.GetRequiredService<SeedService>();
    await seeder.SeedRoles();
}

app.Run();