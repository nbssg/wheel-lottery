$listener = [System.Net.HttpListener]::new()
$listener.Prefixes.Add("http://localhost:3000/")
$listener.Start()
Write-Output "Server started on http://localhost:3000"
while ($listener.IsListening) {
    $context = $listener.GetContext()
    $localPath = $context.Request.Url.LocalPath
    if ($localPath -eq '/' -or $localPath -eq '') { $localPath = '/wheel.html' }
    $filePath = Join-Path "C:\Users\nbhh\Documents\Codex\2026-06-11\goal\outputs" $localPath.TrimStart('/')
    if (Test-Path $filePath) {
        $content = [System.IO.File]::ReadAllBytes($filePath)
        $ext = [System.IO.Path]::GetExtension($filePath)
        $mime = switch ($ext) { '.html' {'text/html; charset=utf-8'} '.css' {'text/css'} '.js' {'application/javascript'} '.png' {'image/png'} '.jpg' {'image/jpeg'} default {'application/octet-stream'} }
        $context.Response.ContentType = $mime
        $context.Response.ContentLength64 = $content.Length
        $context.Response.OutputStream.Write($content, 0, $content.Length)
    } else {
        $bytes = [System.Text.Encoding]::UTF8.GetBytes("404 Not Found: $filePath")
        $context.Response.StatusCode = 404
        $context.Response.ContentType = 'text/plain; charset=utf-8'
        $context.Response.OutputStream.Write($bytes, 0, $bytes.Length)
    }
    $context.Response.Close()
}
