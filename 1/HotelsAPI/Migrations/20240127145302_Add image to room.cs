using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace HotelsAPI.Migrations
{
    /// <inheritdoc />
    public partial class Addimagetoroom : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "Image",
                table: "Rooms",
                type: "text",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Image",
                table: "Rooms");
        }
    }
}
