using HotelsAPI.Models;
using HotelsAPI.Models.Dto;

namespace HotelsAPI.Services;

public interface IRoomService
{
    Task<List<Room>> GetAllRooms(string? searchInput, SortingValue? sortingInput);

    Task<Room?> GetRoomByID(int id);

    Task<Room> AddRoom(RoomDto obj);

    Task<Room?> UpdateRoom(int id, RoomDto obj);

    Task<bool> DeleteRoomByID(int id);
    Task<List<RoomType>> GetAllRoomTypes();
}
