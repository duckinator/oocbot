import net/StreamSocket

IRCBot: class {

  socket: StreamSocket
  server: String
  port: Int
  botnick: String

  init: func (=server, =port, =botnick) {
    socket = StreamSocket new(server, port)
    socket remote toString() println()
  }
  
  connect: func {
    socket connect()
    raw("USER " + botnick + " 0 0 :IRC bot written in ooc")
    raw("NICK " + botnick)
  }

  raw: func (line: String) {
    socket send(line + "\r\n")
    ("<< " + line) println()
  }

  run: func {
    buffer: String
    bytesRecv: Int

    raw("JOIN #bots")

    while (1) { // !socket isClosed() ) {
      buffer = String new(100)
      bytesRecv = socket receive(buffer, 100)
      "Recv %d bytes!" format(bytesRecv) println()
      "Data = '%s'" format(buffer) println()
    }

    socket close()
  }
}

bot:= IRCBot new("irc.eighthbit.net", 6667, "oocbot")
bot connect()
bot run()
