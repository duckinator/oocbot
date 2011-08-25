import net/TCPSocket, text/StringTokenizer, structs/ArrayList

ret: String
params := ArrayList<String> new()

sock := TCPSocket new("irc.ninthbit.net", 6667)
sock connect(|conn|
    conn out write("NICK oocbot\r\n")
    conn out write("USER oocbot * * :IRC bot in ooc\r\n")

    conn in eachLine(|line|
        line println()

        parts := line split(':')
        parts[1] split(' ') each(|word|
            params add(word)
        )
        params add(parts[1])
    
        ret = match(params[1]) {
            case "PING" =>
                "PONG %s" format(params[2..-1] join(" "))
            case "001"  =>
                "JOIN #bots"
            case "PRIVMSG" =>
                "PRIVMSG %s :TADA" format(params[2])
            case => ""
        }

        if (!ret empty?()) {
            ret  println()
            conn out write(ret + "\r\n")
        }

        params clear()
        sock connected?
    )
)
