require! {
    "request": request
    "fs": fs
    "jconv": jconv 
}

folder = "./raw/"

host = "http://aigis.gcwiki.info"

urls = {
    melee : '/?%B6%E1%C0%DC%B7%BF'
    range : '/?%B1%F3%B5%F7%CE%A5%B7%BF'
    sapphire : '/?%C6%C3%BC%EC%A5%EC%A5%A2'
    black : '/?%A5%D6%A5%E9%A5%C3%A5%AF'
    platinum : '/?%A5%D7%A5%E9%A5%C1%A5%CA'
    golden : '/?%A5%B4%A1%BC%A5%EB%A5%C9'
    silver : '/?%A5%B7%A5%EB%A5%D0%A1%BC'
    bronze : '/?%A5%D6%A5%ED%A5%F3%A5%BA'
    iron : '/?%A5%A2%A5%A4%A5%A2%A5%F3'
}

download_html = (name, url) ->
    request.get {url:host+url, encoding:null}, (err, resp, body) ->
        buffer = jconv.convert body, \EUCJP, \UTF8
        (err) <- fs.writeFile folder+name+".html", buffer.toString! 
        console.log name+".html finished!"

for name, url of urls
    download_html name, url
