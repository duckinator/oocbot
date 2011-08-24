import net/TCPSocket, text/StringTokenizer, structs/ArrayList
import net/ServerSocket // Note: This should be moved to TCPSocket

IRCBot: class {
    nick, username, realname, server, prefix, channel: String
    port: SizeT
    sock: TCPSocket
    conn: ReaderWriterPair /* Rename ReaderWriterPair -> TCPReaderWriterPair? */
    
    init: func (=nick, =username, =realname, =server, =port, =prefix, =channel) {
        // Empty
    }

    connect: func {
        sock = TCPSocket new(server, port)
        sock connect()
        /* We need a wrapper akin to ServerSocket accept() */
        conn = ReaderWriterPair new(sock)
        conn out write("NICK %s\r\nUSER %s * * :%s\r\n" format(nick, username, realname))
    }

    run: func {
        connect()
        conn in eachLine(|line|
            /* FIXME: Since readLine() is blocking, we can safely assume
             *+ that if `line` is empty at this point, it means may 
             *+ somehow be missing the fact that the socket is closed.
             * This is probably a bug, and needs to be addressed.
             */
            if (line empty?()) {
                sock close()
                return false
            }
            
            line println()
            
            ret := handle(line)
            
            if (!ret empty?()) {
                ret  println()
                conn out write(ret + "\r\n")
            }
            
            sock connected?
        )
    }

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
                "JOIN %s" format(channel)
            case "PRIVMSG" =>
                "PRIVMSG %s :TADA" format(params[2])
            case => ""
        }
    }
}

bot := IRCBot new("oocbot", "oocbot", "IRC bot written in ooc", "irc.ninthbit.net", 6667, ".", "#bots")
bot run()