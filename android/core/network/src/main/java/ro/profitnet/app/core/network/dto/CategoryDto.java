package ro.profitnet.app.core.network.dto;

import com.google.gson.annotations.SerializedName;

/** The {@code Category} schema. */
public final class CategoryDto {

    @SerializedName("id")
    public String id;

    @SerializedName("parentId")
    public String parentId;

    @SerializedName("slug")
    public String slug;

    @SerializedName("name")
    public String name;

    @SerializedName("iconKey")
    public String iconKey;

    @SerializedName("isVehicle")
    public Boolean isVehicle;
}
