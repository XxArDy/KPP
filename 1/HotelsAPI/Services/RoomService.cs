using HotelsAPI.Data;
using HotelsAPI.Models;
using HotelsAPI.Models.Dto;
using Microsoft.EntityFrameworkCore;

namespace HotelsAPI.Services;

public class RoomService : IRoomService
{
    private readonly ApplicationDbContext _dbContext;

    public RoomService(ApplicationDbContext dbContext)
    {
        _dbContext = dbContext;
    }

    public async Task<Room> AddRoom(RoomDto obj)
    {
        var room = new Room
        {
            Number = obj.Number,
            TypeId = obj.TypeId,
            Description = obj.Description,
            Price = obj.Price
        };

        _dbContext.Rooms.Add(room);
        await _dbContext.SaveChangesAsync();

        return room;
    }

    public async Task<bool> DeleteRoomByID(int id)
    {
        var room = await _dbContext.Rooms.FindAsync(id);

        if (room == null)
        {
            return false;
        }

        _dbContext.Rooms.Remove(room);
        await _dbContext.SaveChangesAsync();

        return true;
    }

    public async Task<List<Room>> GetAllRooms()
    {
        return await _dbContext.Rooms.Include(room => room.Type).ToListAsync();
    }

    public async Task<Room?> GetRoomByID(int id)
    {
        return await _dbContext.Rooms.Include(room => room.Type).FirstOrDefaultAsync(r => r.Id == id);
    }

    public async Task<Room?> UpdateRoom(int id, RoomDto obj)
    {
        var room = await _dbContext.Rooms.FindAsync(id);

        if (room == null)
        {
            return null;
        }

        room.Number = obj.Number;
        room.TypeId = obj.TypeId;
        room.Description = obj.Description;
        room.Price = obj.Price;

        await _dbContext.SaveChangesAsync();

        return room;
    }
}
