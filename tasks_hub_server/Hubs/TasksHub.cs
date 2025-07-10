using Microsoft.AspNetCore.SignalR;
using tasks_hub_server.Models;

namespace tasks_hub_server.Hubs
{
    public class TasksHub : Hub
    {
        // In‐memory task list (shared by all connections)
        private static readonly List<TaskDto> _tasks = new();

        // Called by clients to add a new task
        public async Task AddTask(string title)
        {
            var task = new TaskDto(Guid.NewGuid().ToString(), title);
            _tasks.Add(task);

            // Broadcast the updated list to *all* connected clients
            await Clients.All.SendAsync("TasksUpdated", _tasks);
        }
    }
}
