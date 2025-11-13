{ ... }: {
  # Hardware can be turned on and off here
  board.hardware.enabled = {
    # If you are using Orange Pi 5 Plus, uncomment the line below to turn the LEDs off
    # leds = false;

    # Uncomment the line below to turn on the AP6275P Wi-Fi module
    # wifi-ap6275p = true;
  };
  networking.hostName = "orangepi5plus";
}
