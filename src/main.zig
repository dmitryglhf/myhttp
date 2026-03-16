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

        while (true) {
            var buf: [1024]u8 = undefined;
            const n = try conn.stream.read(&buf);
            if (n == 0) break;
            _ = try conn.stream.write(buf[0..n]);
        }
    }
}
