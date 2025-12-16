import 'package:dart_appwrite/dart_appwrite.dart';

// --- CONFIGURATION ---
const String endpoint = 'https://fra.cloud.appwrite.io/v1'; // Or your self-hosted IP
const String projectId = '68c477bd0025144ebd1c';
const String apiKey = 'standard_f9fbabf0be23ce976607c74585d7adf7f421b36708337fa050e405bc56427b3255cf81db6741273e2fe38c4dd7526a3bd4cb949cbf17c13af933ea1a88d5ccc7c1106ee30b45058df5aebbf3139eea260f89003c8c2f5d8ffa943d7d014b2d8bf9c9763730c3496f2f476917778a3bbfce14df7df53a0a4923a09809e599d2db'; // MUST have 'databases.write' scope
const String dbId = 'food_delivery_db';

void main() async {
  print("🚀 Starting Database Setup...");

  final client = Client()
      .setEndpoint(endpoint)
      .setProject(projectId)
      .setKey(apiKey);

  // final databases = TablesDB(client);
  final databases = Databases(client);

  try {
    // 1. Create Database
    try {
      await databases.get(databaseId: dbId);
      print("✅ Database '$dbId' already exists.");
    } catch (e) {
      await databases.create(databaseId: dbId, name: 'Food Delivery DB');
      print("✅ Created Database: $dbId");
    }

    // 2. Create Collections & Attributes
    await _setupUsers(databases);
    await _setupStoreConfig(databases);
    await _setupCategories(databases);
    await _setupProducts(databases);
    await _setupOrders(databases);
    await _setupAddresses(databases);
    await _setupCoupons(databases);

    print("\n🎉 SETUP COMPLETE! Your Appwrite backend is ready.");
  } catch (e) {
    print("❌ Critical Error: $e");
  }
}

// --- HELPER TO CREATE COLLECTION ---
Future<void> _createCollection(Databases db, String id, String name, List<Function> attributes, List<String> permissions) async {
  try {
    await db.getCollection(databaseId: dbId, collectionId: id);
    print("🔹 Collection '$name' exists. Checking attributes...");
  } catch (e) {
    await db.createCollection(
      databaseId: dbId,
      collectionId: id,
      name: name,
      permissions: permissions,
      documentSecurity: true,
    );
    print("✅ Created Collection: $name");
  }

  // Create Attributes (Ignore if already exists)
  for (var createAttr in attributes) {
    try {
      await createAttr();
      // Small delay to prevent race conditions in Appwrite Cloud
      await Future.delayed(Duration(milliseconds: 200));
    } catch (e) {
      // Ignore "Attribute already exists" error
      if (!e.toString().contains('409')) {
        print("   ⚠️ Error adding attribute: $e");
      }
    }
  }
}

// --- DEFINING SPECIFIC SCHEMAS ---

Future<void> _setupUsers(Databases db) async {
  await _createCollection(db, 'users', 'Users', [
        () => db.createStringAttribute(databaseId: dbId, collectionId: 'users', key: 'name', size: 128, xrequired: true),
        () => db.createStringAttribute(databaseId: dbId, collectionId: 'users', key: 'email', size: 128, xrequired: true),
        () => db.createStringAttribute(databaseId: dbId, collectionId: 'users', key: 'phone', size: 20, xrequired: true),
        () => db.createEnumAttribute(databaseId: dbId, collectionId: 'users', key: 'role', elements: ['customer', 'driver', 'manager', 'admin'], xrequired: true),
        () => db.createStringAttribute(databaseId: dbId, collectionId: 'users', key: 'fcm_token', size: 255, xrequired: false),
        () => db.createFloatAttribute(databaseId: dbId, collectionId: 'users', key: 'wallet_balance', xrequired: false, xdefault: 0.0),
        () => db.createBooleanAttribute(databaseId: dbId, collectionId: 'users', key: 'is_active', xrequired: true, xdefault: true),
  ], [
    Permission.read(Role.users()),          // Everyone can see
    Permission.write(Role.team('admin')), // Only 'admin' team can edit
  ]);
}

Future<void> _setupStoreConfig(Databases db) async {
  await _createCollection(db, 'store_config', 'Store Config', [
        () => db.createStringAttribute(databaseId: dbId, collectionId: 'store_config', key: 'currency_symbol', size: 10, xrequired: true, xdefault: '\$'),
        () => db.createFloatAttribute(databaseId: dbId, collectionId: 'store_config', key: 'delivery_fee_per_km', xrequired: true),
        () => db.createFloatAttribute(databaseId: dbId, collectionId: 'store_config', key: 'min_delivery_fee', xrequired: true),
        () => db.createFloatAttribute(databaseId: dbId, collectionId: 'store_config', key: 'free_delivery_above', xrequired: false),
        () => db.createIntegerAttribute(databaseId: dbId, collectionId: 'store_config', key: 'max_delivery_radius', xrequired: true), // in meters
        () => db.createStringAttribute(databaseId: dbId, collectionId: 'store_config', key: 'store_location', size: 1000, xrequired: true), // JSON string
        () => db.createBooleanAttribute(databaseId: dbId, collectionId: 'store_config', key: 'is_store_open', xrequired: true, xdefault: true),
  ], [
    Permission.read(Role.any()),          // Everyone can see
    Permission.write(Role.team('admin')), // Only 'admin' team can edit
  ]);
}

Future<void> _setupCategories(Databases db) async {
  await _createCollection(db, 'categories', 'Categories', [
        () => db.createStringAttribute(databaseId: dbId, collectionId: 'categories', key: 'name', size: 64, xrequired: true),
        () => db.createStringAttribute(databaseId: dbId, collectionId: 'categories', key: 'image_id', size: 64, xrequired: true),
        () => db.createIntegerAttribute(databaseId: dbId, collectionId: 'categories', key: 'sort_order', xrequired: true),
        () => db.createBooleanAttribute(databaseId: dbId, collectionId: 'categories', key: 'is_active', xrequired: true, xdefault: true),
  ], [
    Permission.read(Role.any()),          // Everyone can see
    Permission.write(Role.team('admin')), // Only 'admin' team can edit
  ]);
}

Future<void> _setupProducts(Databases db) async {
  await _createCollection(db, 'products', 'Products', [
        () => db.createStringAttribute(databaseId: dbId, collectionId: 'products', key: 'category_id', size: 64, xrequired: true),
        () => db.createStringAttribute(databaseId: dbId, collectionId: 'products', key: 'name', size: 128, xrequired: true),
        () => db.createStringAttribute(databaseId: dbId, collectionId: 'products', key: 'description', size: 1024, xrequired: false),
        () => db.createFloatAttribute(databaseId: dbId, collectionId: 'products', key: 'price', xrequired: true),
        () => db.createFloatAttribute(databaseId: dbId, collectionId: 'products', key: 'old_price', xrequired: false),
        () => db.createStringAttribute(databaseId: dbId, collectionId: 'products', key: 'image_id', size: 64, xrequired: true),
        () => db.createBooleanAttribute(databaseId: dbId, collectionId: 'products', key: 'is_veg', xrequired: true, xdefault: false),
        () => db.createBooleanAttribute(databaseId: dbId, collectionId: 'products', key: 'is_available', xrequired: true, xdefault: true),
        () => db.createStringAttribute(databaseId: dbId, collectionId: 'products', key: 'variants', size: 5000, xrequired: false), // Huge JSON String
  ], [
    Permission.read(Role.any()),          // Everyone can see
    Permission.write(Role.team('admin')), // Only 'admin' team can edit
  ]);
}

Future<void> _setupOrders(Databases db) async {
  await _createCollection(db, 'orders', 'Orders', [
        () => db.createStringAttribute(databaseId: dbId, collectionId: 'orders', key: 'customer_id', size: 64, xrequired: true),
        () => db.createStringAttribute(databaseId: dbId, collectionId: 'orders', key: 'driver_id', size: 64, xrequired: false),
        () => db.createEnumAttribute(databaseId: dbId, collectionId: 'orders', key: 'status', elements: ['pending', 'cooking', 'ready', 'on_way', 'delivered', 'cancelled'], xrequired: true),
        () => db.createEnumAttribute(databaseId: dbId, collectionId: 'orders', key: 'payment_method', elements: ['cod', 'online', 'wallet'], xrequired: true),
        () => db.createEnumAttribute(databaseId: dbId, collectionId: 'orders', key: 'payment_status', elements: ['paid', 'unpaid'], xrequired: true),
        () => db.createFloatAttribute(databaseId: dbId, collectionId: 'orders', key: 'total_amount', xrequired: true),
        () => db.createFloatAttribute(databaseId: dbId, collectionId: 'orders', key: 'delivery_fee', xrequired: true),
        () => db.createStringAttribute(databaseId: dbId, collectionId: 'orders', key: 'delivery_address', size: 2000, xrequired: true), // Snapshot JSON
        () => db.createStringAttribute(databaseId: dbId, collectionId: 'orders', key: 'order_items', size: 5000, xrequired: true), // Snapshot JSON
        () => db.createDatetimeAttribute(databaseId: dbId, collectionId: 'orders', key: 'created_at', xrequired: true),
  ], [
    Permission.create(Role.users()),      // Any logged-in user can buy
    Permission.read(Role.users()), // Optional: Verified users only
    Permission.read(Role.team('admin')),  // Admins can see all orders
    Permission.update(Role.team('admin')), // Admins can update status
  ]);
}

Future<void> _setupAddresses(Databases db) async {
  await _createCollection(db, 'addresses', 'Addresses', [
        () => db.createStringAttribute(databaseId: dbId, collectionId: 'addresses', key: 'user_id', size: 64, xrequired: true),
        () => db.createStringAttribute(databaseId: dbId, collectionId: 'addresses', key: 'label', size: 64, xrequired: true),
        () => db.createStringAttribute(databaseId: dbId, collectionId: 'addresses', key: 'address', size: 512, xrequired: true),
    // Note: Creating Spatial Indexes via API is complex, we just store string Lat/Lng for now.
    // In production, manually add a Spatial Index on this location attribute in Console.
        () => db.createStringAttribute(databaseId: dbId, collectionId: 'addresses', key: 'location', size: 128, xrequired: true),
  ], [
    Permission.create(Role.users()),      // Any logged-in user can add
    Permission.read(Role.users()), // Users can see their own addresses
    Permission.update(Role.users()), // Users can update their own addresses
    Permission.delete(Role.users()), // Users can delete their own addresses
  ]);
}

Future<void> _setupCoupons(Databases db) async {
  await _createCollection(db, 'coupons', 'Coupons', [
        () => db.createStringAttribute(databaseId: dbId, collectionId: 'coupons', key: 'code', size: 32, xrequired: true),
        () => db.createEnumAttribute(databaseId: dbId, collectionId: 'coupons', key: 'discount_type', elements: ['percent', 'fixed'], xrequired: true),
        () => db.createFloatAttribute(databaseId: dbId, collectionId: 'coupons', key: 'discount_amount', xrequired: true),
        () => db.createFloatAttribute(databaseId: dbId, collectionId: 'coupons', key: 'min_purchase', xrequired: true),
        () => db.createDatetimeAttribute(databaseId: dbId, collectionId: 'coupons', key: 'expiry_date', xrequired: true),
  ], [
    Permission.read(Role.any()),          // Everyone can see
    Permission.write(Role.team('admin')), // Only 'admin' team can edit
  ]);
}