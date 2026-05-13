<?php

require_once __DIR__ . '/../config.php';

// Créer le dossier database s'il n'existe pas
if (!is_dir(dirname(DB_PATH))) {
    mkdir(dirname(DB_PATH), 0755, true);
}

// Connexion SQLite
try {
    $pdo = new PDO('sqlite:' . DB_PATH);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
} catch (PDOException $e) {
    die("Erreur de connexion : " . $e->getMessage());
}

// Création des tables
$sql = "
-- Table departements
CREATE TABLE IF NOT EXISTS departements (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nom TEXT NOT NULL,
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Table types_conge
CREATE TABLE IF NOT EXISTS types_conge (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    libelle TEXT NOT NULL,
    jours_annuels INTEGER DEFAULT 0,
    deductible INTEGER DEFAULT 1,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Table employes
CREATE TABLE IF NOT EXISTS employes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nom TEXT NOT NULL,
    prenom TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL,
    role TEXT DEFAULT 'employe' CHECK(role IN ('employe', 'rh', 'admin')),
    departement_id INTEGER,
    date_embauche DATE,
    actif INTEGER DEFAULT 1,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (departement_id) REFERENCES departements(id) ON DELETE SET NULL
);

-- Table soldes
CREATE TABLE IF NOT EXISTS soldes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    employe_id INTEGER NOT NULL,
    type_conge_id INTEGER NOT NULL,
    annee INTEGER NOT NULL,
    jours_attribues INTEGER DEFAULT 0,
    jours_pris INTEGER DEFAULT 0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employe_id) REFERENCES employes(id) ON DELETE CASCADE,
    FOREIGN KEY (type_conge_id) REFERENCES types_conge(id) ON DELETE CASCADE
);

-- Table conges
CREATE TABLE IF NOT EXISTS conges (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    employe_id INTEGER NOT NULL,
    type_conge_id INTEGER NOT NULL,
    date_debut DATE NOT NULL,
    date_fin DATE NOT NULL,
    nb_jours INTEGER DEFAULT 0,
    motif TEXT,
    statut TEXT DEFAULT 'en_attente' CHECK(statut IN ('en_attente', 'approuvee', 'refusee', 'annulee')),
    commentaire_rh TEXT,
    traite_par INTEGER,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employe_id) REFERENCES employes(id) ON DELETE CASCADE,
    FOREIGN KEY (type_conge_id) REFERENCES types_conge(id) ON DELETE CASCADE,
    FOREIGN KEY (traite_par) REFERENCES employes(id) ON DELETE SET NULL
);
";

try {
    $pdo->exec($sql);
    echo "Tables créées avec succès.\n";
} catch (PDOException $e) {
    die("Erreur lors de la création des tables : " . $e->getMessage());
}

// Insertion des données initiales
require_once __DIR__ . '/seeder.php';
