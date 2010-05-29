import threading/Thread, os/Time
import net/StreamSocket
import ../spry/spry/[IRC, Commands, Prefix]

TestBot: class extends IRC {
    defaultChannel: String

    init: func ~TestBot (.nick, .user, .realname, .server, .port, .trigger) {
        super(nick, user, realname, server, port, trigger)
    }

    init: func ~defaultChannel (.nick, .user, .realname, .server, .port, .trigger, =defaultChannel) {
        super(nick, user, realname, server, port, trigger)
    }

    onSend: func (cmd: Command) {
        ">> " print()
        cmd toString() println()
    }

    onAll: func (cmd: Command) {
        cmd toString() println()
    }

    onNick: func (cmd: Nick) {
        "%s is now known as %s" format(cmd prefix, cmd nick()) println()
    }

//    onJoin: func (cmd: Join) {
//        if(cmd prefix nick != this nick)
//            say("Welcome to %s, %s!" format(cmd channel(), cmd prefix nick))
//    }

    onChannelMessage: func (cmd: Message) {
        handleCommand(cmd)
    }

    onPrivateMessage: func (cmd: Message) {
        handleCommand(cmd)
    }

    onUnhandled: func (cmd: Command) {
        if (cmd command == "001") {
            send(Join new(cmd irc, "#offtopic") as Command)
        }
    }

    handleCommand: func (msg: Message) {
        if(!addressed) return

        i := commandString indexOf(' ')
        cmd := commandString[0..i]

        if(i != -1) i += 1
        rest := commandString[i..-1]

        match(cmd) {
            case "join" =>
                Join new(this, rest) send()
            case "ping" =>
                reply("pong")
            case "echo" =>
                reply(rest)
            case "trigger" =>
                trigger = rest
                reply("Done.")
            case "help" =>
                reply("ping, echo, trigger, help")
            case "die" =>
                if(rest == "   ") exit(0)
        }
    }
}

main: func {
    ninthbit := TestBot new("oocbot", "oocbot", "IRC bot using the spry lib, written in ooc", "irc.ninthbit.net", 6667, ".", "#offtopic")
    freenode := TestBot new("oocbot", "oocbot", "IRC bot using the spry lib, written in ooc", "irc.ninthbit.net", 6667, ".", "#ooc-lang")
    Thread new(|| ninthbit run()) start()
//    Thread new(|| freenode run()) start()
    freenode run()
    
/*    while (true) {
        Time sleepSec(10)
    }*/
}
