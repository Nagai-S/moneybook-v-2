def a_id_trans(a_id)
  if a_id==13
    account_id=1
  elsif a_id==12
    account_id=3
  elsif a_id==15
    account_id=9
  elsif a_id==14
    account_id=8
  elsif a_id==16
    account_id=10
  else
    account_id=a_id
  end

  return account_id
end

def g_id_trans(g_id)
  if g_id==18
    genre_id=14
  elsif g_id==20
    genre_id=15
  elsif g_id==21
    genre_id=16
  else
    genre_id=g_id
  end

  return genre_id
end

def c_id_trans(c_id)
  if c_id==7
    card_id=3
  else
    card_id=c_id
  end

  return card_id
end