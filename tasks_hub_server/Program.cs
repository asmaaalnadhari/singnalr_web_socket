using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using tasks_hub_server.Hubs;

var builder = WebApplication.CreateBuilder(args);

// 1️⃣ Configure CORS so your Flutter client can connect
builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
    {
        policy.WithOrigins("http://localhost:8080")  // adjust to your Flutter web or emulator URL
              .AllowAnyHeader()
              .AllowAnyMethod()
              .AllowCredentials();
    });
});

// 2️⃣ Register SignalR services
builder.Services.AddSignalR();

var app = builder.Build();

// 3️⃣ Enable CORS globally
app.UseCors();

// 4️⃣ Map the Hub endpoint at /tasksHub
app.MapHub<TasksHub>("/tasksHub");

app.Run();
