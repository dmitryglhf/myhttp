const std = @import("std");
const net = std.net;

pub fn main() !void {
    const address = net.Address.parseIp("0.0.0.0", 8080) catch unreachable;
    var server = try address.listen(.{
        .reuse_address = true,
    });
    defer server.deinit();

    std.debug.print("listening on :8080\n", .{});

    while (true) {
        const conn = try server.accept();
        defer conn.stream.close();

        var buf: [1024]u8 = undefined;
        const n = conn.stream.read(&buf) catch |err| {
            std.debug.print("read error: {}\n", .{err});
            continue;
        };
        if (n == 0) continue;

        const response =
            "HTTP/1.1 200 OK\r\n" ++
            "Content-Type: text/plain\r\n" ++
            "Content-Length: 11\r\n" ++
            "\r\n" ++
            "hello world";
        _ = conn.stream.write(response) catch |err| {
            std.debug.print("write error: {}\n", .{err});
            continue;
        };
    }
}
