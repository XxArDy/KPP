using HotelsAPI.Data;
using HotelsAPI.Models;
using HotelsAPI.Models.Dto;
using Microsoft.EntityFrameworkCore;

namespace HotelsAPI.Services;

public class ClientService : IClientService
{
    private readonly ApplicationDbContext _dbContext;

    public ClientService(ApplicationDbContext dbContext)
    {
        _dbContext = dbContext;
    }

    public async Task<Client> AddClient(ClientDto obj)
    {
        var existingClient = await _dbContext.Clients
        .FirstOrDefaultAsync(c => c.Phone == obj.Phone);

        if (existingClient != null)
        {

            return existingClient;
        }

        var client = new Client
        {
            FirstName = obj.FirstName,
            LastName = obj.LastName,
            Phone = obj.Phone
        };

        await _dbContext.Clients.AddAsync(client);
        await _dbContext.SaveChangesAsync();

        return client;
    }

    public async Task<bool> DeleteClientByID(int id)
    {
        var client = await _dbContext.Clients.FindAsync(id);

        if (client == null)
        {
            return false;
        }

        _dbContext.Clients.Remove(client);
        await _dbContext.SaveChangesAsync();

        return true;
    }

    public async Task<List<Client>> GetAllClients(string? searchInput, SortingValue? sortingInput)
    {
        IQueryable<Client> query = _dbContext.Clients;

        if (!string.IsNullOrEmpty(searchInput))
        {
            query = query.Where(client =>
                client.FirstName!.ToLower().Contains(searchInput.ToLower()) ||
                client.LastName!.ToLower().Contains(searchInput.ToLower()) ||
                client.Phone!.ToLower().Contains(searchInput.ToLower()));
        }

        if (sortingInput != null)
        {
            switch (sortingInput)
            {
                case SortingValue.asc:
                    query = query.OrderBy(client => client.FirstName);
                    break;
                case SortingValue.desc:
                    query = query.OrderByDescending(client => client.FirstName);
                    break;
            }
        }

        return await query.ToListAsync();
    }

    public async Task<Client?> GetClientByID(int id)
    {
        return await _dbContext.Clients.FindAsync(id);
    }

    public async Task<Client?> UpdateClient(int id, ClientDto obj)
    {
        var client = await _dbContext.Clients.FindAsync(id);

        if (client == null)
        {
            return null;
        }

        client.FirstName = obj.FirstName;
        client.LastName = obj.LastName;
        client.Phone = obj.Phone;

        await _dbContext.SaveChangesAsync();

        return client;
    }
}
