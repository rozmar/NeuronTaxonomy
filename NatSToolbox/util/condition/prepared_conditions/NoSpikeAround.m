function condition = NoSpikeAround(from, to)
  condition = NoEventAround('spk', from, to);
end