
require "inotify/namespace"
require "ffi"

class Inotify::Event < FFI::Struct
  layout :wd, :int,
         :mask, :uint32,
         :cookie, :uint32,
         :len, :uint32

  # last piece is the name.
         #:name, :string,

  attr_accessor :name
  attr_accessor :original_pointer

  def initialize(pointer)
    if pointer.is_a?(String)
      pointer = FFI::MemoryPointer.from_string(pointer)
    end

    super(pointer)
  end

  def self.from_io(io)
    data = io.read(self.size)
    pointer = FFI::MemoryPointer.from_string(data)
    event = self.new(pointer)
    event.name = io.read(event[:len]).split("\0", 2).first
    return event
  end

  def to_s
  end
end
