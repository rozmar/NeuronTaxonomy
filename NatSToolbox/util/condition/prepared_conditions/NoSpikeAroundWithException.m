function condition = NoSpikeAroundWithException(no_from, no_to, yes_from, yes_to)
  condition(1) = NoSpikeAround(no_from, no_to);
  condition(2) = createCondition('spk',[yes_from,yes_to],1);
end