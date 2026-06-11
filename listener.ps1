$listener = [System.Net.HttpListener]::new()
$listener.Prefixes.Add("http://localhost:8080/")
$listener.Start()
Write-Output "Server started on http://localhost:8080"
while ($listener.IsListening) {
    $context = $listener.GetContext()
    $filePath = Join-Path "C:\Users\nbhh\Documents\Codex\2026-06-11\goal\outputs" $context.Request.Url.LocalPath.TrimStart('/')
    if ($filePath -match '\\$') { $filePath = Join-Path $filePath 'wheel.html' }
    if (Test-Path $filePath) {
        $content = [System.IO.File]::ReadAllBytes($filePath)
        $ext = [System.IO.Path]::GetExtension($filePath)
        $mime = switch ($ext) { '.html' {'text/html; charset=utf-8'} '.css' {'text/css'} '.js' {'application/javascript'} default {'application/octet-stream'} }
        $context.Response.ContentType = $mime
        $context.Response.ContentLength64 = $content.Length
        $context.Response.OutputStream.Write($content, 0, $content.Length)
    } else {
        $bytes = [System.Text.Encoding]::UTF8.GetBytes("404 Not Found: $filePath")
        $context.Response.StatusCode = 404
        $context.Response.OutputStream.Write($bytes, 0, $bytes.Length)
    }
    $context.Response.Close()
}
