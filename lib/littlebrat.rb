# -*- encoding: utf-8 -*-
require 'gosu'

class LittleBrat < Gosu::Window
  LETTER_LIMIT = 60
  def initialize width=Gosu.screen_width, height=Gosu.screen_height, fullscreen=true
    # Full resolution, fullscreen
    super width, height, !!fullscreen #force to boolean for Gosu
    self.caption = "Leave me alone you little brat!"
    # The letters the little brat hits on the keyboard
    @letters, @new_letters = [], []
    # Load up the instructions to show at first
    @letters.push Instructions.new(self)
    @beeps = load_beeps
    @redraw = true # init this because it needs to be true or false
  end

  def load_beeps
    Dir.glob(File.dirname(__FILE__) + '/../sounds/**/*.WAV').map do |beep|
      Gosu::Sample.new(self, beep)
    end
  end

  def update
    if !@new_letters.empty?
      # Add new letter to the queue
      while str = @new_letters.shift
        @letters.push(Letter.new self, str)
      end
      beep # Only beep once per game loop
      # Keep the total number of letter sprites at a managable number
      @letters = @letters[-LETTER_LIMIT..-1] if @letters.size > LETTER_LIMIT
      # We updated the letters, so we need to redraw
      @redraw = true
    end
  end

  def draw
    @letters.each { |letter| letter.draw }
    @redraw = false # Done drawing, don't need to draw no more
  end

  def needs_redraw?; @redraw; end # Don't paint/draw unless we need to

  def needs_cursor?; false;   end # Don't show the cursor, even on Ubuntu

  def button_down id # Callback, not on main thread
    close if close? # Close if we press the right keys
    @new_letters.push str_from_button_id(id)
  end

  def str_from_button_id id
    self.button_id_to_char(id) || random_letter
  end

  def random_letter
    @random_letters ||= %w{ ▲ ▼ ☻ ♠ ♣ ♥ ♦ ☀ ☁ ☂ ✔ ✘ ☎ ✈ ✪ }
    @random_letters[rand @random_letters.size]
  end

  def close?
    (button_down? Gosu::KbEscape        or
     button_down? Gosu::KbLeftControl   or
     button_down? Gosu::KbRightControl) &&
    (button_down? Gosu::KbQ         or button_down? Gosu::KbW or
     button_down? Gosu::KbZ         or button_down? Gosu::KbC or
     button_down? Gosu::KbBackspace or button_down? Gosu::KbDelete)
  end

  def beep
    @beeps[rand @beeps.size].play
  end

  class Instructions
    def initialize window, text = "Let's shut those little brats up!"
      @image = Gosu::Image.from_text window,
                                     "#{text}\nPress CTRL+Q to exit",
                                     Gosu::default_font_name,
                                     100
      @color = 0xffffff00
      @x, @y = 10, 10
    end

    def draw
      @image.draw @x, @y, 1, 0.5, 0.5, @color
    end
  end

  class Letter
    def initialize window, text
      text_height = random_text_size window
      @image      = Gosu::Image.from_text window, text,
                                          Gosu::default_font_name,
                                          text_height
      @color      = random_color # Image text is white, so this is to modulate it
      @x, @y      = random_position window, text_height
    end

    def draw
      @image.draw @x, @y, 1, 0.5, 0.5, @color
    end

    def random_text_size(window)
      (window.height / (rand + 1)).to_i
    end

    def random_color
      color       = Gosu::Color.new 0xff000000
      color.red   = random_byte
      color.green = random_byte
      color.blue  = random_byte
      color
    end

    def random_byte
      rand(255 - 40) + 40
    end

    def random_position window, text_height
      [ rand * window.width  - (text_height / 4),
        rand * window.height - (text_height / 4) ]
    end
  end
end