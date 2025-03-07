<?php
$serverRoot = "http://localhost"; // Sesuaikan dengan domain server lokal kamu
$projectsDir = realpath(__DIR__ . "/../www"); // Direktori proyek utama
$activeProjectFile = realpath(__DIR__ . "/..") . "/active_project.txt";

// Dapatkan path dari direktori tempat skrip ini dijalankan
$currentDir = getcwd();
$projectName = basename($currentDir); // Ambil nama folder saat ini

// Periksa apakah folder ini ada di dalam direktori proyek utama
if (!str_starts_with(realpath($currentDir), $projectsDir)) {
    echo "❌ Skrip harus dijalankan dari dalam folder proyek!\n";
    exit(1);
}

// Simpan proyek aktif ke file
file_put_contents($activeProjectFile, "www/$projectName");

// Buat link akses proyek
$projectURL = "$serverRoot/$projectName";

echo "✅ Proyek aktif diubah menjadi: $projectName\n";
echo "🌐 Akses proyek di: $projectURL\n";
?>
