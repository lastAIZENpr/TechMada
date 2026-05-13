-- Base de données TechMada - Système de gestion des congés

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

-- Insertion des départements
INSERT INTO departements (nom, description) VALUES ('Direction', 'Direction générale');
INSERT INTO departements (nom, description) VALUES ('RH', 'Ressources Humaines');
INSERT INTO departements (nom, description) VALUES ('IT', 'Département technique');

-- Insertion des types de congé
INSERT INTO types_conge (libelle, jours_annuels, deductible) VALUES ('Congé annuel', 25, 1);
INSERT INTO types_conge (libelle, jours_annuels, deductible) VALUES ('Congé maladie', 10, 1);
INSERT INTO types_conge (libelle, jours_annuels, deductible) VALUES ('Congé sans solde', 0, 0);

-- Insertion des employés (mot de passe: password123)
INSERT INTO employes (nom, prenom, email, password, role, departement_id, date_embauche, actif) 
VALUES ('Admin', 'Principal', 'admin@techmada.mg', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin', 1, '2020-01-01', 1);

INSERT INTO employes (nom, prenom, email, password, role, departement_id, date_embauche, actif) 
VALUES ('RH', 'Manager', 'rh@techmada.mg', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'rh', 2, '2021-01-01', 1);

INSERT INTO employes (nom, prenom, email, password, role, departement_id, date_embauche, actif) 
VALUES ('Rakoto', 'Jean', 'jean@techmada.mg', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'employe', 3, '2023-01-01', 1);

INSERT INTO employes (nom, prenom, email, password, role, departement_id, date_embauche, actif) 
VALUES ('Rasoa', 'Marie', 'marie@techmada.mg', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'employe', 3, '2023-06-01', 1);

-- Insertion des soldes (année 2025)
INSERT INTO soldes (employe_id, type_conge_id, annee, jours_attribues, jours_pris) VALUES (1, 1, 2025, 25, 0);
INSERT INTO soldes (employe_id, type_conge_id, annee, jours_attribues, jours_pris) VALUES (1, 2, 2025, 10, 0);
INSERT INTO soldes (employe_id, type_conge_id, annee, jours_attribues, jours_pris) VALUES (1, 3, 2025, 0, 0);
INSERT INTO soldes (employe_id, type_conge_id, annee, jours_attribues, jours_pris) VALUES (2, 1, 2025, 25, 0);
INSERT INTO soldes (employe_id, type_conge_id, annee, jours_attribues, jours_pris) VALUES (2, 2, 2025, 10, 0);
INSERT INTO soldes (employe_id, type_conge_id, annee, jours_attribues, jours_pris) VALUES (2, 3, 2025, 0, 0);
INSERT INTO soldes (employe_id, type_conge_id, annee, jours_attribues, jours_pris) VALUES (3, 1, 2025, 25, 0);
INSERT INTO soldes (employe_id, type_conge_id, annee, jours_attribues, jours_pris) VALUES (3, 2, 2025, 10, 0);
INSERT INTO soldes (employe_id, type_conge_id, annee, jours_attribues, jours_pris) VALUES (3, 3, 2025, 0, 0);
INSERT INTO soldes (employe_id, type_conge_id, annee, jours_attribues, jours_pris) VALUES (4, 1, 2025, 25, 0);
INSERT INTO soldes (employe_id, type_conge_id, annee, jours_attribues, jours_pris) VALUES (4, 2, 2025, 10, 0);
INSERT INTO soldes (employe_id, type_conge_id, annee, jours_attribues, jours_pris) VALUES (4, 3, 2025, 0, 0);

-- Insertion des congés de test
INSERT INTO conges (employe_id, type_conge_id, date_debut, date_fin, nb_jours, motif, statut, commentaire_rh, traite_par) 
VALUES (3, 1, '2025-02-01', '2025-02-05', 5, 'Vacances famille', 'en_attente', NULL, 2);

INSERT INTO conges (employe_id, type_conge_id, date_debut, date_fin, nb_jours, motif, statut, commentaire_rh, traite_par) 
VALUES (4, 1, '2025-01-15', '2025-01-17', 3, 'Raison personnelle', 'approuvee', 'Approuvé', 2);
