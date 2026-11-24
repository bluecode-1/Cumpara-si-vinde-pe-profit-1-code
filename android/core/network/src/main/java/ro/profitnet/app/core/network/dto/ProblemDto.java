package ro.profitnet.app.core.network.dto;

import com.google.gson.annotations.SerializedName;

import java.util.List;
import java.util.Map;

/** RFC 9457 {@code application/problem+json} body. */
public final class ProblemDto {

    @SerializedName("type")
    public String type;

    @SerializedName("title")
    public String title;

    @SerializedName("status")
    public Integer status;

    /** Server-side text; never shown to the user. */
    @SerializedName("detail")
    public String detail;

    @SerializedName("code")
    public String code;

    @SerializedName("errors")
    public Map<String, List<String>> errors;
}
