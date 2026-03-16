const std = @import("std");
const net = std.net;

pub fn main() !void {
    // listen on 0.0.0.0:8080
    const address = net.Address.parseIp("0.0.0.0", 8080) catch unreachable;
    var server = try address.listen(.{
        .reuse_address = true,
    });
    defer server.deinit();

    std.debug.print("listening on :8080\n", .{});

    // accept single connection
    const conn = try server.accept();
    defer conn.stream.close();

    // read
    var buf: [1024]u8 = undefined;
    const n = try conn.stream.read(&buf);

    // write again
    _ = try conn.stream.write(buf[0..n]);
}
