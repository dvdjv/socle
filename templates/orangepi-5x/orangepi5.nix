{ ... }: {
  # Hardware can be turned on and off here
  board.hardware.enabled = {
    # If you are useing Orange Pi 5, uncomment the line below to turn the LED off
    # led = false;

    # Uncomment the line below to turn on the AP6275P Wi-Fi module
    # wifi-ap6275p = true;
  };
  networking.hostName = "orangepi5";
}
