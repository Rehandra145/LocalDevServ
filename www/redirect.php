<?php
// Baca proyek aktif dari file
$activeProjectFile = __DIR__ . '/active_project.txt';
$defaultProject = 'none'; // Ganti dengan proyek default

// Cek apakah file proyek aktif ada
if (file_exists($activeProjectFile)) {
    $activeProject = trim(file_get_contents($activeProjectFile));
    if (!is_dir(__DIR__ . '/' . $activeProject)) {
        $activeProject = $defaultProject; // Jika proyek tidak ada, pakai default
    }
} else {
    $activeProject = $defaultProject; // Jika tidak ada file, pakai default
}

// Redirect ke proyek aktif
header("Location: /$activeProject/");
exit;
?>
