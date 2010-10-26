require 'router/error'

module Expect4r::Router::Junos
module Ping

  def ping(host, arg={})

    pct_success = arg.delete(:pct_success) || 100

    output = exec(ping_cmd(host, arg), arg)

    r = output[0].find { |x| p x ; x =~/(\d+) packets transmitted, (\d+) packets received, (\d+)\% packet loss/}

    if r && 
      Regexp.last_match(1) && 
      Regexp.last_match(2) && 
      Regexp.last_match(3)

      success = 100 - $3.to_i
      tx = $2.to_i
      rx = $3.to_i
      
      if (100 - $3.to_i) < pct_success
        raise ::Expect4r::Router::Error::PingError.new(@host, host, pct_success, tx, rx, output)
      else
        [$1.to_i,[$2.to_i,$3.to_i],output]
      end

    else
      raise ::Expect4r::Router::Error::PingError.new(@host, host, pct_success, $1.to_i, tx, rx, output)
    end

  end

private

  def ping_cmd(host, arg={})
    cmd = "ping #{host}"
    cmd += " rapid"
    cmd += " count #{arg[:count] || arg[:repeat_count]}" if arg[:count] || arg[:repeat_count]
    cmd += " size #{arg[:size] || arg[:datagram_size]}"  if arg[:size]  || arg[:datagram_size] 
    cmd += " pattern #{arg[:pattern]}"                   if arg[:pattern]
    cmd += " tos #{arg[:tos]}"                           if arg[:tos]
    cmd += " ttl #{arg[:ttl]}"                           if arg[:ttl]
    cmd
  end

end
end

__END__


if __FILE__ == $0
  
  module Expect4r
    module Router
      module Junos
      end
    end
  end

end

if __FILE__ == $0
    
  require "test/unit"

  class TestLibraryFileName < Test::Unit::TestCase
    include Expect4r::Router::Junos::Ping
    def test_case_name
      
      assert_equal 'ping 1.1.1.1 rapid', ping_cmd( '1.1.1.1')
      assert_equal 'ping 1.1.1.1 rapid size 256', ping_cmd( '1.1.1.1', :size=>256)
      assert_equal 'ping 1.1.1.1 rapid size 256', ping_cmd( '1.1.1.1', :datagram_size=>256)
      assert_equal 'ping 1.1.1.1 rapid pattern 0xdead', ping_cmd( '1.1.1.1', :pattern=>'0xdead')
      assert_equal 'ping 1.1.1.1 rapid tos 2', ping_cmd( '1.1.1.1', :tos=>2)
      assert_equal 'ping 1.1.1.1 rapid ttl 2', ping_cmd( '1.1.1.1', :ttl=>2)
      
    end
  end
  
end


__END__

5 packets transmitted, 5 packets received, 0% packet loss
round-trip min/avg/max/stddev = 1.483/17.024/78.904/30.940 ms



Possible completions:
  <host>               Hostname or IP address of remote host
  atm                  Ping remote Asynchronous Transfer Mode node
  bypass-routing       Bypass routing table, use specified interface
  count                Number of ping requests to send (1..2000000000 packets)
  detail               Display incoming interface of received packet
  do-not-fragment      Don't fragment echo request packets (IPv4)
  inet                 Force ping to IPv4 destination
  inet6                Force ping to IPv6 destination
  interface            Source interface (multicast, all-ones, unrouted packets)
  interval             Delay between ping requests (seconds)
  logical-router       Name of logical router
+ loose-source         Intermediate loose source route entry (IPv4)
  mpls                 Ping label-switched path
  no-resolve           Don't attempt to print addresses symbolically
  pattern              Hexadecimal fill pattern
  rapid                Send requests rapidly (default count of 5)
  record-route         Record and report packet's path (IPv4)
  routing-instance     Routing instance for ping attempt
  size                 Size of request packets (0..65468 bytes)
  source               Source address of echo request
  strict               Use strict source route option (IPv4)
+ strict-source        Intermediate strict source route entry (IPv4)
  tos                  IP type-of-service value (0..255)
  ttl                  IP time-to-live value (IPv6 hop-limit value) (hops)
  verbose              Display detailed output
  vpls                 Ping VPLS MAC address
  wait                 Delay after sending last packet (seconds)