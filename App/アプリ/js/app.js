$(function(){
    $("#recipe_group_content").css("display", "none");
    $("#sports_group_content").css("display", "none");
 
    $("#recipe_group").click(function(){
        $("#recipe_group_content").toggle();
    });

    $("#sports_group").click(function(){
        $("#sports_group_content").toggle();
    });
});