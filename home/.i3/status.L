
battery 0 {
        format = "%status %percentage %remaining"
	integer_battery_capacity = true
}

wireless wlp1s0 {
        format_up = "%quality @ %essid (%ip)"
        format_down = "W"
}

order += "battery 0"
#order += "ipv6"
#order += "disk /dev/sdb1"
#order += "disk /mnt/flash"
#order += "disk /"
#order += "run_watch DHCP"
#order += "run_watch VPN"
order += "wireless wlp1s0"
#order += "ethernet enp0s25"
order += "load"
order += "tztime local"
