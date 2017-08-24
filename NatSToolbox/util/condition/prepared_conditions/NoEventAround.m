function condition = NoEventAround(eventName, from, to)
  condition = createCondition(eventName,[from,to],0);
end