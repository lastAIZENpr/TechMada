# Système de Gestion des Congés - Entreprise TechMada

## Description
Système de gestion des congés en PHP pur avec SQLite. 3 rôles : Employé, Responsable RH, Administrateur.

## Installation

**Option 1 : Importer le fichier SQL**
```bash
sqlite3 database/techmada.db < database/techmada.sql
```

**Option 2 : Exécuter le script PHP**
```bash
php database/init.php
```

## Structure

- `config.php` : Configuration de l'application
- `db.php` : Connexion à la base de données
- `database/techmada.sql` : Fichier SQL complet (tables + données)
- `database/init.php` : Script PHP de création
- `database/techmada.db` : Fichier SQLite (créé après installation)

## Comptes de test

| Rôle | Email | Mot de passe |
|------|-------|--------------|
| Admin | admin@techmada.mg | password123 |
| RH | rh@techmada.mg | password123 |
| Employé | jean@techmada.mg | password123 |
| Employé | marie@techmada.mg | password123 |

## Base de données

5 tables dans un seul fichier SQLite :
1. **departements** : Départements de l'entreprise
2. **types_conge** : Types de congé (annuel, maladie, sans solde)
3. **employes** : Employés avec rôles (employe, rh, admin)
4. **soldes** : Soldes de congés par employé et par type
5. **conges** : Demandes de congé avec statuts

## Utilisation

Inclure `db.php` dans vos fichiers pour accéder à la base :

```php
<?php
require_once 'db.php';
$db = getDB();

// Exemple de requête
$employes = $db->query("SELECT * FROM employes")->fetchAll();
```
