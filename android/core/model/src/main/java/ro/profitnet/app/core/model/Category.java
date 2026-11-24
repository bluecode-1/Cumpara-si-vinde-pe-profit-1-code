package ro.profitnet.app.core.model;

import java.util.Objects;

/** A node of the category tree. Top-level categories have no parent. */
public final class Category {

    private final String id;
    private final String parentId;
    private final String slug;
    private final String name;
    private final String iconKey;
    private final boolean vehicle;

    public Category(String id, String parentId, String slug, String name, String iconKey,
            boolean vehicle) {
        this.id = Objects.requireNonNull(id, "id");
        this.parentId = parentId;
        this.slug = Objects.requireNonNull(slug, "slug");
        this.name = Objects.requireNonNull(name, "name");
        this.iconKey = iconKey;
        this.vehicle = vehicle;
    }

    public String getId() {
        return id;
    }

    /** {@code null} for top-level categories. */
    public String getParentId() {
        return parentId;
    }

    public String getSlug() {
        return slug;
    }

    public String getName() {
        return name;
    }

    /** May be {@code null}. */
    public String getIconKey() {
        return iconKey;
    }

    public boolean isVehicle() {
        return vehicle;
    }

    public boolean isTopLevel() {
        return parentId == null;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (!(o instanceof Category)) {
            return false;
        }
        Category other = (Category) o;
        return vehicle == other.vehicle
                && id.equals(other.id)
                && Objects.equals(parentId, other.parentId)
                && slug.equals(other.slug)
                && name.equals(other.name)
                && Objects.equals(iconKey, other.iconKey);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, parentId, slug, name, iconKey, vehicle);
    }
}
