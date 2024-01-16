using HotelsAPI.Models;
using HotelsAPI.Models.Dto;

namespace HotelsAPI.Services;

public interface IClientService
{
    Task<List<Client>> GetAllClients();

    Task<Client?> GetClientByID(int id);

    Task<Client> AddClient(ClientDto obj);

    Task<Client?> UpdateClient(int id, ClientDto obj);

    Task<bool> DeleteClientByID(int id);
}
