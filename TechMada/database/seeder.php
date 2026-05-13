<?php

require_once __DIR__ . '/../config.php';

try {
    $pdo = new PDO('sqlite:' . DB_PATH);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("Erreur de connexion : " . $e->getMessage());
}

// Départements
$departements = [
    ['Direction', 'Direction générale'],
    ['RH', 'Ressources Humaines'],
    ['IT', 'Département technique']
];

$stmt = $pdo->prepare("INSERT INTO departements (nom, description) VALUES (?, ?)");
foreach ($departements as $dep) {
    $stmt->execute($dep);
}
echo "Départements insérés.\n";

// Types de congé
$types_conge = [
    ['Congé annuel', 25, 1],
    ['Congé maladie', 10, 1],
    ['Congé sans solde', 0, 0]
];

$stmt = $pdo->prepare("INSERT INTO types_conge (libelle, jours_annuels, deductible) VALUES (?, ?, ?)");
foreach ($types_conge as $type) {
    $stmt->execute($type);
}
echo "Types de congé insérés.\n";

// Employés
$password = password_hash('password123', PASSWORD_DEFAULT);
$annee = date('Y');

$employes = [
    ['Admin', 'Principal', 'admin@techmada.mg', $password, 'admin', 1, '2020-01-01', 1],
    ['RH', 'Manager', 'rh@techmada.mg', $password, 'rh', 2, '2021-01-01', 1],
    ['Rakoto', 'Jean', 'jean@techmada.mg', $password, 'employe', 3, '2023-01-01', 1],
    ['Rasoa', 'Marie', 'marie@techmada.mg', $password, 'employe', 3, '2023-06-01', 1]
];

$stmt = $pdo->prepare("INSERT INTO employes (nom, prenom, email, password, role, departement_id, date_embauche, actif) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
foreach ($employes as $emp) {
    $stmt->execute($emp);
}
echo "Employés insérés.\n";

// Soldes initiaux
$stmt_solde = $pdo->prepare("INSERT INTO soldes (employe_id, type_conge_id, annee, jours_attribues, jours_pris) VALUES (?, ?, ?, ?, ?)");

for ($i = 1; $i <= 4; $i++) {
    // Congé annuel (type 1)
    $stmt_solde->execute([$i, 1, $annee, 25, 0]);
    // Congé maladie (type 2)
    $stmt_solde->execute([$i, 2, $annee, 10, 0]);
    // Congé sans solde (type 3)
    $stmt_solde->execute([$i, 3, $annee, 0, 0]);
}
echo "Soldes insérés.\n";

// Congés (demandes de test)
$conges = [
    [3, 1, '2025-02-01', '2025-02-05', 5, 'Vacances famille', 'en_attente', null, 2],
    [4, 1, '2025-01-15', '2025-01-17', 3, 'Raison personnelle', 'approuvee', 'Approuvé', 2],
];

$stmt_conge = $pdo->prepare("INSERT INTO conges (employe_id, type_conge_id, date_debut, date_fin, nb_jours, motif, statut, commentaire_rh, traite_par) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)");
foreach ($conges as $conge) {
    $stmt_conge->execute($conge);
}
echo "Congés insérés.\n";

echo "\n=== Base de données initialisée avec succès ===\n";
