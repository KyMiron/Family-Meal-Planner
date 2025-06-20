String mealPlan = '''
      mealplans (
        id TEXT PRIMARY KEY, 
        date TEXT NOT NULL,
        recipeId TEXT NOT NULL
      )
      ''';
String recipes = '''
      recipes (
        id TEXT PRIMARY KEY,
        title TEXT,
        description TEXT,
        imagePath TEXT
      )
      ''';
String ingredients = '''
      ingredients (
        id TEXT PRIMARY KEY,
        recipeId TEXT,
        name TEXT,
        quantity REAL,
        unit TEXT,
        FOREIGN KEY(recipeId) REFERENCES recipes(id) ON DELETE CASCADE
      )
      ''';
