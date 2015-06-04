# Not sure if this is a good idea ¯\_(ツ)_/¯

def standard_layout(page)
  erb :'layout--standard', :layout => :'top-layout' do
    erb page
  end
end

def skinny_layout(page)
  erb :'layout--skinny', :layout => :'top-layout' do
    erb page
  end
end
