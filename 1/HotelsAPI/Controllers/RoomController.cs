using HotelsAPI.Models;
using HotelsAPI.Models.Dto;
using HotelsAPI.Services;
using Microsoft.AspNetCore.Mvc;

namespace HotelsAPI.Controllers;

/// <summary>
/// API Controller for managing rooms.
/// </summary>
[ApiController]
[Route("api/[controller]")]
public class RoomController : ControllerBase
{
	private readonly IRoomService _roomService;

	/// <summary>
	/// Initializes a new instance of the <see cref="RoomController"/> class.
	/// </summary>
	/// <param name="roomService">The room service.</param>
	public RoomController(IRoomService roomService)
	{
		_roomService = roomService;
	}

	/// <summary>
	/// Gets a list of all rooms.
	/// </summary>
	/// <returns>List of rooms</returns>
	/// <response code="200">Returns list of rooms</response>
	[HttpGet]
	[ProducesResponseType(StatusCodes.Status200OK)]
	public async Task<IActionResult> GetAllRooms(
		[FromQuery] string? _search,
		[FromQuery] SortingValue? _order)
	{
		var rooms = await _roomService.GetAllRooms(_search, _order);
		return Ok(rooms);
	}

	/// <summary>
	/// Gets room details by ID.
	/// </summary>
	/// <param name="id">The room ID</param>
	/// <returns>Room details</returns>
	/// <response code="200">Returns room details</response>
	/// <response code="404">If the room is null</response>
	[HttpGet("{id}")]
	[ProducesResponseType(StatusCodes.Status200OK)]
	[ProducesResponseType(StatusCodes.Status404NotFound)]
	public async Task<IActionResult> GetRoomById(int id)
	{
		var room = await _roomService.GetRoomByID(id);
		if (room == null)
		{
			return NotFound();
		}
		return Ok(room);
	}

	/// <summary>
	/// Adds a new room.
	/// </summary>
	/// <param name="roomDto">The room data</param>
	/// <returns>The newly created room</returns>
	/// <remarks>
	/// Sample request:
	///
	///     POST /Room
	///     {
	///        "number": 101,
	///        "typeId": 1,
	///        "description": "Standard Room",
	///        "price": 100.00
	///     }
	///
	/// </remarks>
	/// <response code="201">Returns the newly created room</response>
	/// <response code="409">If the room has conflict</response>
	[HttpPost]
	[ProducesResponseType(StatusCodes.Status201Created)]
	[ProducesResponseType(StatusCodes.Status409Conflict)]
	public async Task<IActionResult> AddRoom([FromBody] RoomDto roomDto)
	{
		var addedRoom = await _roomService.AddRoom(roomDto);
		return CreatedAtAction(nameof(GetRoomById), new { id = addedRoom.Id }, addedRoom);
	}

	/// <summary>
	/// Updates an existing room.
	/// </summary>
	/// <param name="id">The room ID</param>
	/// <param name="roomDto">The updated room data</param>
	/// <returns>The updated room</returns>
	/// <remarks>
	/// Sample request:
	///
	///     PUT /Room/{id}
	///     {
	///        "number": 101,
	///        "typeId": 1,
	///        "description": "Standard Room",
	///        "price": 120.00
	///     }
	///
	/// </remarks>
	/// <response code="200">Returns the updated room</response>
	/// <response code="404">If the room is null</response>
	[HttpPut("{id}")]
	[ProducesResponseType(StatusCodes.Status200OK)]
	[ProducesResponseType(StatusCodes.Status404NotFound)]
	public async Task<IActionResult> UpdateRoom(int id, [FromBody] RoomDto roomDto)
	{
		var updatedRoom = await _roomService.UpdateRoom(id, roomDto);
		if (updatedRoom == null)
		{
			return NotFound();
		}
		return Ok(updatedRoom);
	}

	/// <summary>
	/// Deletes a room by ID.
	/// </summary>
	/// <param name="id">The room ID</param>
	/// <returns>No content if the room is deleted, NotFound if the room is not found</returns>
	/// <response code="204">Returns the succeed deleted status</response>
	/// <response code="404">If the room is null</response>
	[HttpDelete("{id}")]
	[ProducesResponseType(StatusCodes.Status204NoContent)]
	[ProducesResponseType(StatusCodes.Status404NotFound)]
	public async Task<IActionResult> DeleteRoomById(int id)
	{
		var result = await _roomService.DeleteRoomByID(id);
		if (!result)
		{
			return NotFound();
		}
		return NoContent();
	}

	/// <summary>
	/// Get all room types.
	/// </summary>
	/// <returns>List of room types</returns>
	/// <response code="200">Returns the list of room types</response>
	[HttpGet("allType")]
	[ProducesResponseType(StatusCodes.Status200OK)]
	public async Task<IActionResult> GetAllRoomTypes()
	{
		var types = await _roomService.GetAllRoomTypes();
		return Ok(types);
	}
}
