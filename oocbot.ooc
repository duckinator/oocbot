import net/TCPSocket, text/StringTokenizer, structs/ArrayList
import net/ServerSocket // Note: This should be moved to TCPSocket

handle: func (line: String) -> String {
    params := ArrayList<String> new()
    parts := line split(':')
    parts[1] split(' ') each(|word|
        params add(word)
    )
    params add(parts[1])
    
    match(params[1]) {
        case "PING" =>
            "PONG %s" format(params[2..-1] join(" "))
        case "001"  =>
            "JOIN #bots"
        case "PRIVMSG" =>
            "PRIVMSG %s :TADA" format(params[2])
        case => ""
    }
}

sock := TCPSocket new("irc.ninthbit.net", 6667)
sock connect()

/* We need a wrapper akin to ServerSocket accept() */
conn := ReaderWriterPair new(sock)
conn out write("NICK oocbot\r\n")
conn out write("USER oocbot * * :IRC bot in ooc\r\n")

conn in eachLine(|line|    
    line println()
    
    ret := handle(line)
    
    if (!ret empty?()) {
        ret  println()
        conn out write(ret + "\r\n")
    }
    
    sock connected?
)
